import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../follow/follow_request_state.dart';
import '../follow/follow_request_view_model.dart';

class FollowRequestScreen extends StatefulWidget {
  const FollowRequestScreen({super.key});

  @override
  State<FollowRequestScreen> createState() => _FollowRequestScreenState();
}

class _FollowRequestScreenState extends State<FollowRequestScreen> {
  @override
  void initState() {
    super.initState();

    // 화면 진입 시 요청 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<FollowRequestViewModel>();
      viewModel.loadFollowRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowRequestViewModel>(
      builder: (context, viewModel, child) {
        final state = viewModel.state;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              '팔로우 요청',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FollowRequestState state) {
    // 로딩 상태
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러 상태
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final viewModel = context.read<FollowRequestViewModel>();
                viewModel.loadFollowRequests();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    // 요청이 없는 경우
    if (state.followRequests.isEmpty) {
      return const Center(
        child: Text(
          '받은 팔로우 요청이 없습니다.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    // 요청 목록 표시
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.followRequests.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final request = state.followRequests[index];
        return _buildFollowRequestItem(request);
      },
    );
  }

  Widget _buildFollowRequestItem(request) {
    final viewModel = context.read<FollowRequestViewModel>();

    return Row(
      children: [
        // 프로필 이미지
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD9D9D9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // 프로필 이미지 표시
          child: request.toUserImageUrl.isEmpty
              ? Center(
            child: Icon(
              Icons.person,
              size: 32,
              color: Colors.grey[300],
            ),
          )
              : ClipOval(
            child: Image.network(
              request.toUserImageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.grey[300],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),

        // 사용자 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.toUserName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '팔로우 요청을 보냈습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(request.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),

        // 수락/거절 버튼
        Row(
          children: [
            // 수락 버튼
            Container(
              width: 80,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E8B57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  _handleAcceptRequest(request);
                },
                child: const Text(
                  '수락',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 거절 버튼
            Container(
              width: 80,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                onPressed: () {
                  _handleRejectRequest(request);
                },
                child: const Text(
                  '거절',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleAcceptRequest(request) async {
    final viewModel = context.read<FollowRequestViewModel>();
    await viewModel.acceptFollowRequest(
      requestId: request.id, // 이 필드가 필요합니다
      fromUserId: request.fromUserId,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('팔로우 요청을 수락했습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  void _handleRejectRequest(request) async {
    final viewModel = context.read<FollowRequestViewModel>();
    await viewModel.rejectFollowRequest(
      requestId: request.id, // 이 필드가 필요합니다
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('팔로우 요청을 거절했습니다.'),
            backgroundColor: Colors.orange,
          ),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.month}월 ${date.day}일';
    }
  }
}